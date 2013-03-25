import org.codehaus.gant.GantState

includeTargets << grailsScript("_GrailsInit")
includeTargets << grailsScript("_GrailsClasspath")
includeTargets << grailsScript("_GrailsRun")

target(test: "Compile widget set for vaadin") {
    depends(classpath)
    GantState.verbosity = GantState.VERBOSE
    ant.java(classname: "com.google.gwt.dev.Compiler")
            {
                arg value: '-war'
                arg value: 'web-app'
                arg value: 'Bunnytron'
            }
}


target(widgetset_init: "init") {
    ant.property(name: "widgetset", value: "Bunnytron")
    ant.property(name: "widgetset-path", value: "")
    ant.property(name: "client-side-destination", value: "web-app/VAADIN/widgetsets")
    ant.property(name: "generate.widgetset", value: "1")
}


target(compile_widgetset: "widgetset") {
    depends(classpath, compile, widgetset_init)
    ant.echo message:
            """Compiling $ant.project.properties.'widgetset' into $ant.project.properties."client-side-destination" directory..."""

    ant.java(classname: "com.google.gwt.dev.Compiler", maxmemory: "256m", failonerror: true) {
        arg(value: "-war")
        arg(value: ant.project.properties.'client-side-destination')
        arg(value: ant.project.properties.'widgetset')
        jvmarg(value: "-Xss1024k")
        jvmarg(value: "-Djava.awt.headless=true")
    }
}

setDefaultTarget(compile_widgetset)
