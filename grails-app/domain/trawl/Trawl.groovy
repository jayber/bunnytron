package trawl

import java.util.regex.Pattern

class Trawl {
    private static final String VALID_PATH_QUERY_STRING = "[\\.a-zA-Z0-9\\-_~!\$&'()\\*\\+,;=:@%/]+?\\??[\\.a-zA-Z0-9\\-_~!\$&'()\\*\\+,;=:@%/]+\$"
    private static final Pattern VALID_URL_PATTERN = ~("^http://" + VALID_PATH_QUERY_STRING)

    static constraints = {
        name blank: false
        trawlUrl blank: false, validator: { val, obj -> VALID_URL_PATTERN.matcher(val).matches() ? true : "customValidation.trawlUrl.notValidUrl" }
        lastChecked nullable: true, editable: false
    }

    String name
    String trawlUrl
    Date lastChecked
}
