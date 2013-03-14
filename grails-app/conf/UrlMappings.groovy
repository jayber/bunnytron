class UrlMappings {

    static mappings = {
        "/" {
            controller = "redirect"
            url = "/ui"
        }
        "/index"(view: "index")
        "/ws/article/$id/body/"(controller: "articleRest") {
            action = [GET: "body", POST: "bodySave"]
            constraints {
                id(matches: /\d*/)
            }
        }
        "/$controller/$action?/"()
    }
}