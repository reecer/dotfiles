// Downloads wallpapers from ultrawidewallpapers.net.
//
// Fetches the homepage, extracts image URLs from tab sections (recent, top,
// top-week, great-16-9), and downloads them sequentially. Skips files that
// already exist. Respects Cloudflare rate limits via Retry-After.
//
// Usage: go run ultrawidewallpapers.go [-tabs top-week,recent] [-all] [-o ultrawidewallpapers]
package main

import (
	"flag"
	"fmt"
	"io"
	"net/http"
	"net/http/cookiejar"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"time"
)

const (
	baseURL   = "https://ultrawidewallpapers.net"
	userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"
)

var (
	// Matches tab sections: <div class="tab-content" id="tab-top-week">
	tabRe = regexp.MustCompile(`id="tab-([^"]+)"`)
	// Matches wallpaper links: href="wallpapers/329/highres/aishot-1234.jpg"
	hrefRe = regexp.MustCompile(`href="(wallpapers/[^"]+)"`)

	client *http.Client
)

func main() {
	tabsFlag := flag.String("tabs", "top-week", "comma-separated tab names")
	all := flag.Bool("all", false, "download from all tabs")
	outDir := flag.String("o", "ultrawidewallpapers", "output directory")
	flag.Parse()

	// Cookie jar is required — server returns 429 without session cookies.
	jar, _ := cookiejar.New(nil)
	client = &http.Client{Jar: jar}

	html, err := fetch(baseURL + "/")
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

	selected := strings.Split(*tabsFlag, ",")
	if *all {
		selected = nil // nil means all tabs
	}

	urls := extractURLs(html, selected)
	if len(urls) == 0 {
		fmt.Println("no wallpapers found")
		return
	}
	fmt.Printf("%d unique wallpapers\n\n", len(urls))

	if err := os.MkdirAll(*outDir, 0o755); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

	total := len(urls)
	for i, u := range urls {
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

// fetch GETs a URL and returns the response body as a string.
// Sets User-Agent and Referer headers (server returns 403 without them).
func fetch(url string) (string, error) {
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("User-Agent", userAgent)
	req.Header.Set("Referer", baseURL+"/")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return "", fmt.Errorf("HTTP %d", resp.StatusCode)
	}
	body, err := io.ReadAll(resp.Body)
	return string(body), err
}

// extractURLs finds wallpaper URLs from the given tab sections in the HTML.
// The HTML contains tabs like id="tab-recent", id="tab-top", etc. Each tab's
// content runs from its id attribute to the next tab (or end of HTML).
// If selected is nil, all tabs are included.
func extractURLs(html string, selected []string) []string {
	// Find all tab boundaries in the HTML.
	matches := tabRe.FindAllStringSubmatchIndex(html, -1)

	want := make(map[string]bool, len(selected))
	for _, s := range selected {
		want[strings.TrimSpace(s)] = true
	}
	allTabs := len(selected) == 0

	seen := make(map[string]bool)
	var urls []string

	for i, m := range matches {
		name := html[m[2]:m[3]]
		if !allTabs && !want[name] {
			continue
		}

		// Slice from this tab to the next tab (or end of HTML).
		end := len(html)
		if i+1 < len(matches) {
			end = matches[i+1][0]
		}
		section := html[m[0]:end]

		count := 0
		for _, href := range hrefRe.FindAllStringSubmatch(section, -1) {
			if !seen[href[1]] {
				seen[href[1]] = true
				urls = append(urls, href[1])
				count++
			}
		}
		fmt.Printf("  %s: %d wallpapers\n", name, count)
	}
	return urls
}

// downloadFile fetches a wallpaper to dest with up to 3 retries.
// Writes to a .tmp file first to avoid partial downloads.
// On 429 (Cloudflare rate limit), respects the Retry-After header.
func downloadFile(urlPath, dest string) error {
	fullURL := baseURL + "/" + urlPath

	var lastErr error
	for attempt := range 3 {
		if attempt > 0 {
			time.Sleep(time.Duration(attempt) * time.Second)
		}

		req, _ := http.NewRequest("GET", fullURL, nil)
		req.Header.Set("User-Agent", userAgent)
		req.Header.Set("Referer", baseURL+"/")

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
