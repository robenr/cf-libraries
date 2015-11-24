<!-----------------------------------------------------------------------

Author 	 :	Roben Rajan
Description : Utility library for custom logging

----------------------------------------------------------------------->
<cfcomponent>

    <cffunction name="logData" access="public" returntype="void">
    <cfargument name="path" type="string" required="true">
    <cfargument name="data" type="string" required="true">
        
        <cflock timeout="60" scope="Request" type="Exclusive">
            <cffile action="append"
                    file="#arguments.path#"
                    attributes="normal"
                    output="#arguments.data#">
        </cflock>
    </cffunction>

</cfcomponent>