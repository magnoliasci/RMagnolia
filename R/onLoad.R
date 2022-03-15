.onLoad <- function(libname, pkgname)
{
    # Initialize java VM
    .jinit()

    # Add jar files to class path
    path1 = file.path(system.file(package="RMagnolia"), "java", "Magnolia.jar")
    .jaddClassPath(path1)
    path2 = file.path(system.file(package="RMagnolia"), "java", "antlr-4.5.3-complete.jar")
    .jaddClassPath(path2)
    path3 = file.path(system.file(package="RMagnolia"), "java", "JVodeMin.jar")
    .jaddClassPath(path3)

    #path1 = file.path(system.file(package="RMagnolia"), "java", "Magnolia-2.jar")
    #.jaddClassPath(path1)
}
