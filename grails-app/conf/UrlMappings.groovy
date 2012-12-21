class UrlMappings {

    static mappings = {
        "/" {
            controller = "redirect"
            url = "/ui"
        }
        "/$controller/$action?/"()
    }
}