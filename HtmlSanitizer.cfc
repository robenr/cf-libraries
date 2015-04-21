<cffunction name="htmlSanitizer" returntype="string" access="public" output="false" hint="Remove XSS attacks from the user input">
    <cfargument name="userInput" type="string" required="true" hint="String to be filtered" />

    <!--- Check if the input has \ after " (escape parameter)--->
    <cfif FindNoCase( '\"',arguments.userInput)>
        <cfset local.escape="\\" />
    <cfelse>
        <cfset local.escape="" />
    </cfif>
    <!--- Extract all HTML tags --->
    <cfset local.htmlTags=R EMatchNoCase( "<[^<]+>", arguments.userInput) />
    <!--- Add allowed tags here --->
    <cfset local.allowedTagList="u,ol,li,b,i,ul,br,span,a,</a>" />

    <!--- Add allowed attributes here --->
    <cfset local.allowedAttributes={ } />
    <cfset local.allowedAttributes[ "href"]='href=#local.escape#"(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?#local.escape#"' />
    <cfset local.allowedAttributes[ "target"]='target=#local.escape#"[a-z0-9.:_\-\/]{1,}#local.escape#"' />
    <cfset local.allowedAttributes[ "rel"]='rel=#local.escape#"[a-z0-9.:_\-\/]{1,}#local.escape#"' />

    <cfloop list="#local.allowedTagList#" index="local.listTag">
        <cfset local.inputTags=R EMatchNoCase( "<#local.listTag# [^<]+>", arguments.userInput) />
        <!--- If allowed tags exist in user input --->
        <cfif ArrayLen(local.inputTags)>
            <cfloop from="1" to="#ArrayLen(local.inputTags)#" index="local.inputTag">
                <!--- If it's <a> tag --->
                <cfif local.listTag EQ "a">
                    <!--- Create the a tag we want to use --->
                    <cfset local.cleanAtag="<a" />
                    <cfloop collection="#local.allowedAttributes#" item="local.attribute">
                        <cfset local.attributeValues=R EMatchNoCase( "#local.allowedAttributes["#local.attribute# "]#",local.inputTags[local.inputTag]) />
                        <!--- Remove the link if it's not clean --->
                        <cfif NOT arrayLen(local.attributeValues)>
                            <cfset arguments.userInput=R eplaceNoCase(arguments.userInput,local.inputTags[local.inputTag], "", "all") />
                            <!--- If attribute is clean, use it to create clean a tag  --->
                        <cfelseif arrayLen(local.attributeValues)>
                            <cfset local.cleanAtag=l istAppend(local.cleanAtag,local.attributeValues[arrayLen(local.attributeValues)], " ") />
                        </cfif>
                    </cfloop>
                    <!--- Close the tag and replace with user input --->
                    <cfset local.cleanAtag &=">" />
                    <cfset arguments.userInput=R eplaceNoCase(arguments.userInput,local.inputTags[local.inputTag],local.cleanAtag, "all") />
                    <!--- replace any other allowed tags with the clean version --->
                <cfelse>
                    <cfset arguments.userInput=r eReplaceNoCase(arguments.userInput, "<#local.listTag# [^>]+>", "<#local.listTag#>", "all") />
                </cfif>
            </cfloop>
        </cfif>
    </cfloop>
</cffunction>