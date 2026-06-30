// Downloads wallpapers from wallhaven.cc via its JSON API.
//
// Queries the search API with ratio/resolution filters, then downloads the
// full-size images sequentially into a subfolder. Skips files that already
// exist. Defaults target a 3440x1440 (21:9) ultrawide monitor.
//
// Usage: go run wallhaven.go [-o wallhaven] [-pages 1] [-ratios 21x9]
//                            [-atleast 3440x1440] [-sorting toplist] [-apikey KEY]
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strconv"
	"time"
)

const (
	apiURL    = "https://wallhaven.cc/api/v1/search"
	userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"
)

var client = &http.Client{Timeout: 60 * time.Second}

// searchResponse is the subset of the wallhaven search API we care about.
type searchResponse struct {
	Data []struct {
		Path string `json:"path"` // direct URL to the full-size image
	} `json:"data"`
	Meta struct {
		LastPage int `json:"last_page"`
	} `json:"meta"`
}

func main() {
	outDir := flag.String("o", "wallhaven", "output directory")
	pages := flag.Int("pages", 1, "number of result pages to fetch (24 images each)")
	ratios := flag.String("ratios", "21x9", "comma-separated aspect ratios")
	atleast := flag.String("atleast", "3440x1440", "minimum resolution")
	sorting := flag.String("sorting", "toplist", "sort order (toplist, date_added, random, ...)")
	topRange := flag.String("toprange", "1M", "toplist time window (1d,3d,1w,1M,3M,6M,1y)")
	apikey := flag.String("apikey", "", "wallhaven API key (optional)")
	query := flag.String("q", "", "search query / tags (e.g. \"nature\", \"+landscape -anime\")")
	categories := flag.String("categories", "111", "general/anime/people bitmask (e.g. 100 = general only)")
	flag.Parse()

	if err := os.MkdirAll(*outDir, 0o755); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

	// Collect image URLs across the requested pages.
	var images []string
	for page := 1; page <= *pages; page++ {
		q := url.Values{}
		q.Set("ratios", *ratios)
		q.Set("atleast", *atleast)
		q.Set("sorting", *sorting)
		q.Set("topRange", *topRange)
		q.Set("categories", *categories)
		if *query != "" {
			q.Set("q", *query)
		}
		q.Set("page", strconv.Itoa(page))
		if *apikey != "" {
			q.Set("apikey", *apikey)
		}

		resp, err := fetchSearch(apiURL + "?" + q.Encode())
		if err != nil {
			fmt.Fprintf(os.Stderr, "page %d: %v\n", page, err)
			break
		}
		for _, d := range resp.Data {
			images = append(images, d.Path)
		}
		fmt.Printf("page %d/%d: %d images (last page: %d)\n",
			page, *pages, len(resp.Data), resp.Meta.LastPage)

		if page >= resp.Meta.LastPage {
			break
		}
		time.Sleep(1500 * time.Millisecond) // API limit: 45 req/min
	}

	if len(images) == 0 {
		fmt.Println("no wallpapers found")
		return
	}
	fmt.Printf("\n%d wallpapers\n\n", len(images))

	total := len(images)
	for i, u := range images {
		filename := filepath.Base(u)
		dest := filepath.Join(*outDir, filename)
		n := i + 1

		if _, err := os.Stat(dest); err == nil {
			fmt.Printf("[%d/%d] skip %s\n", n, total, filename)
			continue
		}

		if err := downloadFile(u, dest); err != nil {
			fmt.Printf("[%d/%d] FAIL %s: %v\n", n, total, filename, err)
		} else {
			fmt.Printf("[%d/%d] %s\n", n, total, filename)
		}
		time.Sleep(500 * time.Millisecond)
	}
	fmt.Println("done")
}

// fetchSearch GETs a search API URL and decodes the JSON response.
func fetchSearch(u string) (*searchResponse, error) {
	req, _ := http.NewRequest("GET", u, nil)
	req.Header.Set("User-Agent", userAgent)

	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("HTTP %d", resp.StatusCode)
	}

	var sr searchResponse
	if err := json.NewDecoder(resp.Body).Decode(&sr); err != nil {
		return nil, err
	}
	return &sr, nil
}

// downloadFile fetches an image to dest with up to 3 retries.
// Writes to a .tmp file first to avoid partial downloads.
// On 429 (rate limit), respects the Retry-After header.
func downloadFile(fullURL, dest string) error {
	var lastErr error
	for attempt := range 3 {
		if attempt > 0 {
			time.Sleep(time.Duration(attempt) * time.Second)
		}

		req, _ := http.NewRequest("GET", fullURL, nil)
		req.Header.Set("User-Agent", userAgent)

		resp, err := client.Do(req)
		if err != nil {
			lastErr = err
			continue
		}

		if resp.StatusCode == 429 {
			resp.Body.Close()
			wait := 60
			if s := resp.Header.Get("Retry-After"); s != "" {
				if n, err := strconv.Atoi(s); err == nil {
					wait = n
				}
			}
			fmt.Printf("  rate limited, waiting %ds...\n", wait)
			time.Sleep(time.Duration(wait) * time.Second)
			lastErr = fmt.Errorf("HTTP 429")
			continue
		}

		if resp.StatusCode != 200 {
			resp.Body.Close()
			lastErr = fmt.Errorf("HTTP %d", resp.StatusCode)
			continue
		}

		f, err := os.Create(dest + ".tmp")
		if err != nil {
			resp.Body.Close()
			return err
		}
		_, err = io.Copy(f, resp.Body)
		resp.Body.Close()
		f.Close()

		if err != nil {
			os.Remove(dest + ".tmp")
			lastErr = err
			continue
		}

		return os.Rename(dest+".tmp", dest)
	}
	return lastErr
}
