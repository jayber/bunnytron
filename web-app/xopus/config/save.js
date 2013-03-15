// This function is called when the save button is pressed, or when the save
// function is called on an XMLDocument.
function mySaveFunction(uri, xmlDocument) {
    var result = HTTPTools.postXML(uri, xmlDocument, "UTF-8");

    function getIframeContainerWindow() {
        return window.parent.parent;
    }

    getIframeContainerWindow().updateStatus(result)
    // Show a dialog with the result.
    /*
     return confirm(
     "Called save.aspx\n" +
     "Result: " + result + "\n" +
     "Press OK to update the Save button accordingly.");
     */
}

// Register the save function.
IO.setSaveXMLFunction(mySaveFunction);