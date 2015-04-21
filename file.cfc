<!-----------------------------------------------------------------------

Author 	 :	Roben Rajan
Description : Utility library for file related functions

Borrowed from Coldbox framework

----------------------------------------------------------------------->
<cfcomponent>

<cfset this.CHAR_SETS = "utf-8,iso-8859-1,windows-1252,us-ascii,shift_jis,iso-2022-jp,euc-jp,euc-kr,big5,euc-cn,utf-16" >
<cfset this.DEFAULT_CHAR_SET = "iso-8859-1">

<cffunction name="fileSize" access="public" returntype="string" output="false" hint="Get the filesize of a file.">
<cfargument name="filename"   type="string" required="yes">
<cfargument name="sizeFormat" type="string" required="no" default="bytes" hint="Available formats: [bytes][kbytes][mbytes][gbytes]">
    <cfscript>
    var objFile =  createObject("java","java.io.File");
    objFile.init(JavaCast("string", filename));
    if ( arguments.sizeFormat eq "bytes" )
        return objFile.length();
    if ( arguments.sizeFormat eq "kbytes" )
        return (objFile.length()/1024);
    if ( arguments.sizeFormat eq "mbytes" )
        return (objFile.length()/(1048576));
    if ( arguments.sizeFormat eq "gbytes" )
        return (objFile.length()/1073741824);
    </cfscript>
</cffunction>
        
<cffunction name="removeFile" access="public" hint="Remove a file using java.io.File" returntype="boolean" output="false">
<cfargument name="filename" type="string"  required="yes" hint="The absolute path to the file.">
    <cfscript>
    var fileObj = createObject("java","java.io.File").init(JavaCast("string",arguments.filename));
    return fileObj.delete();
    </cfscript>
</cffunction>
    
<cffunction name="removeExtension" access="public" returntype="string" output="false" hint="Remove the extension of a filename.">
<cfargument name="filename" type="string" required="true">
<cfreturn reReplace(arguments.filename,"\.[^.]*$","")>
</cffunction>

</cfcomponent>