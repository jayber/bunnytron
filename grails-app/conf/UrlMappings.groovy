class UrlMappings {

    static mappings = {
        "/" {
            controller = "redirect"
            url = "/ui"
        }
        "/index"(view: "index")
        "/$controller/$action?/"()
    }
}