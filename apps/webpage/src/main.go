package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
)

type AppInfo struct {
	Version string
	Team    string
	Colour  string
}

func main() {
	var team, version, colour string
	if version = os.Getenv("VERSION"); version == "" {
		version = "Version 0"
	}
	if version = os.Getenv("TEAM"); team == "" {
		team = "Team Unknown"
	}
	if colour = os.Getenv("COLOUR"); colour == "" {
		colour = "red"
	}
	appInfo := AppInfo{
		Version: version,
		Colour:  colour,
		Team:    team,
	}

	log.Println(appInfo.Version, " ", appInfo.Colour, " ", appInfo.Team)

	renderPage(appInfo)
	servePages()
}

func renderPage(appInfo AppInfo) {
	tmpl := template.Must(template.ParseFiles("layout.html"))
	pagePath := "/"
	http.HandleFunc(pagePath, func(w http.ResponseWriter, r *http.Request) {
		if err := tmpl.Execute(w, appInfo); err != nil {
			log.Fatalln("Failed template execution %v", err)
		}
	})
}

func servePages() {
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalln("Receive execute listen and serve failed %v", err)
	}
}
