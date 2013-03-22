package editor

class TElement {

    static constraints = {
        name blank: false
        parent nullable: true, blank: true
    }
    static mapping = {
        parent lazy: false
    }

    String name
    TElement parent

    @Override
    public String toString() {
        return name
    }

    boolean equals(o) {
        if (this.is(o)) return true
        if (!(o instanceof TElement)) return false

        TElement tElement = (TElement) o

        if (name != tElement.name) return false
        if (parent != tElement.parent) return false

        return true
    }

    int hashCode() {
        int result
        result = name.hashCode()
        result = 31 * result + (parent != null ? parent.hashCode() : 0)
        return result
    }
}
