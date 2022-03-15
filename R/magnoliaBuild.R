#' Build a Magnolia model
#'
#' This function builds an executable Magnolia model object
#' from the passed CSL source code.
#'
#' @param code Source CSL code (string) for the model
#' @param filename Name of a file containing the model source code; if a value is supplied for this argument, the @code argument is ignored.
#' @return An executable Magnolia model object
magnoliaBuild <- function(code, filename = NA)
{
    # If a filename is provided, it takes precedence
    # over the code argument
    if(!is.na(filename))
    {
        code <- readr::read_file(filename)
    }

    # First step: translate CSL to java source code
    translator = .jnew("org/magnoliasci/csl/CSLModelTranslator")

    # Use an empty string for the path argument for now.
    jcode = translator$translateModel("model.csl", "", code)

    # Second step: compile java code and create instance of model object
    # Use empty string for lib path for now.
    compiler = .jnew("org/magnoliasci/csl/compiler/DynamicCompiler", "org.magnoliasci.csl.runtime.Model", jcode, "")

    # Add jar files to class path
    path1 = file.path(system.file(package="RMagnolia"), "java", "Magnolia.jar")
    compiler$addExternalLibrary(path1)

    path2 = file.path(system.file(package="RMagnolia"), "java", "antlr-4.5.3-complete.jar")
    compiler$addExternalLibrary(path2)

    path3 = file.path(system.file(package="RMagnolia"), "java", "JVodeMin.jar")
    compiler$addExternalLibrary(path3)

    diags = compiler$compile()
    diags

    model = compiler$getModelObject();

    return(model)
}

