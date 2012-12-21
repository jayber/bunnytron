package editor

class RedirectController {

    def index() {
        redirect(url: params.url, permanent: false)
    }
}
