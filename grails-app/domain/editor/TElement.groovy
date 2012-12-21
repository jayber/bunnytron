package editor

class TElement {

    static constraints = {
        name blank: false
        parent nullable: true, blank: true
    }

    String name
    TElement parent

    @Override
    public String toString() {
        return name
    }
}
