package editor

class Person {

    static constraints = {
        name blank: false
    }

    String name

    @Override
    String toString() {
        return name
    }
}
