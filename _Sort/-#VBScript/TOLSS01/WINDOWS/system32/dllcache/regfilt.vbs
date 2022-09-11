Option Explicit

'
' these GUIDs are all defined in nntpfilt.idl
'
' the OnPostEarly event GUID
Const GUIDComCatOnPostEarly = "{C028FD86-F943-11d0-85BD-00C04FB960EA}"
' the OnPost event GUID
Const GUIDComCatOnPost = "{C028FD83-F943-11d0-85BD-00C04FB960EA}"
' the OnPostFinal event GUID
Const GUIDComCatOnPostFinal = "{C028FD85-F943-11d0-85BD-00C04FB960EA}"
' the NNTP source type
Const GUIDSourceType = "{C028FD82-F943-11d0-85BD-00C04FB960EA}"

' the NNTP service display name.  This is used to key which service to
' edit
Const szService = "nntpsvc"

' the event manager object.  This is used to communicate with the 
' event binding database.
Dim EventManager
Set EventManager = WScript.CreateObject("Event.Manager")

'
' register a new sink with event manager
'
' iInstance - the instance to work against
' szEvent - OnPostEarly, OnPost or OnPostFinal
' szDisplayName - the display name for this new sink
' szProgID - the progid to call for this event
' szRule - the rule to set for this event
'
public sub RegisterSink(iInstance, szEvent, szDisplayName, szProgID, szRule)
	Dim SourceType
	Dim szSourceDisplayName
	Dim Source
	Dim Binding
	Dim GUIDComCat

	' figure out which event they are trying to register with and set
	' the comcat for this event in GUIDComCat
	select case LCase(szEvent)
		case "onpostearly"
			GUIDComCat = GUIDComCatOnPostEarly
		case "onpost"
			GUIDComCat = GUIDComCatOnPost
		case "onpostfinal"
			GUIDComCat = GUIDComCatOnPostFinal
		case else
			WScript.echo "invalid event: " + szEvent
			exit sub
	end select

	' enumerate through each of the registered instances for the NNTP source
	' type and look for the display name that matches the instance display
	' name
	set SourceType = EventManager.SourceTypes(GUIDSourceType)
	szSourceDisplayName = szService + " " + iInstance
	for each Source in SourceType.Sources
		if Source.DisplayName = szSourceDisplayName then
			' we've found the desired instance.  now add a new binding
			' with the right event GUID.  by not specifying a GUID to the
			' Add method we get server events to create a new ID for this
			' event
			set Binding = Source.GetBindingManager.Bindings(GUIDComCat).Add("")
			' set the binding properties
			Binding.DisplayName = szDisplayName
			Binding.SinkClass = szProgID
			' register a rule with the binding
			Binding.SourceProperties.Add "Rule", szRule
			' save the binding
			Binding.Save
			WScript.Echo "registered " + szDisplayName
			exit sub
		end if
	next
end sub

'
' unregister a previously registered sink
'
' iInstance - the instance to work against
' szEvent - OnPostEarly, OnPost or OnPostFinal
' szDisplayName - the display name of the event to remove
'
public sub UnregisterSink(iInstance, szEvent, szDisplayName)
	Dim SourceType
	Dim GUIDComCat
	Dim szSourceDisplayName
	Dim Source
	Dim Bindings
	Dim Binding

	select case LCase(szEvent)
		case "onpostearly"
			GUIDComCat = GUIDComCatOnPostEarly
		case "onpost"
			GUIDComCat = GUIDComCatOnPost
		case "onpostfinal"
			GUIDComCat = GUIDComCatOnPostFinal
		case else
			WScript.echo "invalid event: " + szEvent
			exit sub
	end select

	' find the source for this instance
	set SourceType = EventManager.SourceTypes(GUIDSourceType)
	szSourceDisplayName = szService + " " + iInstance
	for each Source in SourceType.Sources
		if Source.DisplayName = szSourceDisplayName then
			' find the binding by display name.  to do this we enumerate
			' all of the bindings and try to match on the display name
			set Bindings = Source.GetBindingManager.Bindings(GUIDComCat)
			for each Binding in Bindings
				if Binding.DisplayName = szDisplayName then
					' we've found the binding, now remove it
					Bindings.Remove(Binding.ID)
					WScript.Echo "removed " + szDisplayName + " " + Binding.ID
				end if
			next
		end if
	next
end sub

'
' add or remove a property from the source or sink propertybag for an event
'
' iInstance - the NNTP instance to edit
' szEvent - the event type (OnPostEarly, OnPost or OnPostFinal)
' szDisplayName - the display name of the event
' szPropertyBag - the property bag to edit ("source" or "sink")
' szOperation - "add" or "remove"
' szPropertyName - the name to edit in the property bag
' szPropertyValue - the value to assign to the name (ignored for remove)
'
public sub EditProperty(iInstance, szEvent, szDisplayName, szPropertyBag, szOperation, szPropertyName, szPropertyValue)
	Dim SourceType
	Dim GUIDComCat
	Dim szSourceDisplayName
	Dim Source
	Dim Bindings
	Dim Binding
	Dim PropertyBag

	select case LCase(szEvent)
		case "onpostearly"
			GUIDComCat = GUIDComCatOnPostEarly
		case "onpost"
			GUIDComCat = GUIDComCatOnPost
		case "onpostfinal"
			GUIDComCat = GUIDComCatOnPostFinal
		case else
			WScript.echo "invalid event: " + szEvent
			exit sub
	end select

	' find the source for this instance
	set SourceType = EventManager.SourceTypes(GUIDSourceType)
	szSourceDisplayName = szService + " " + iInstance
	for each Source in SourceType.Sources
		if Source.DisplayName = szSourceDisplayName then
			set Bindings = Source.GetBindingManager.Bindings(GUIDComCat)
			' find the binding by display name.  to do this we enumerate
			' all of the bindings and try to match on the display name
			for each Binding in Bindings
				if Binding.DisplayName = szDisplayName then
					' figure out which set of properties we want to modify
					' based on the szPropertyBag parameter
					select case LCase(szPropertyBag)
						case "source"
							set PropertyBag = Binding.SourceProperties
						case "sink"
							set PropertyBag = Binding.SinkProperties
						case else
							WScript.echo "invalid propertybag: " + szPropertyBag
							exit sub
					end select
					' figure out what operation we want to perform
					select case LCase(szOperation)
						case "remove"
							' they want to remove szPropertyName from the
							' property bag
							PropertyBag.Remove szPropertyName
							WScript.echo "removed property " + szPropertyName
						case "add"
							' add szPropertyName to the property bag and 
							' set its value to szValue.  if this value
							' already exists then this will change  the value
							' it to szValue.
							PropertyBag.Add szPropertyName, szPropertyValue
							WScript.echo "set property " + szPropertyName + " to " + szPropertyValue
						case else
							WScript.echo "invalid operation: " + szOperation
							exit sub
					end select
					' save the binding
					Binding.Save
				end if
			next
		end if
	next
end sub

'
' this helper function takes an IEventSource object and a event category
' and dumps all of the bindings for this category under the source
'
' Source - the IEventSource object to display the bindings for
' GUIDComCat - the event category to display the bindings for
'
public sub DisplaySinksHelper(Source, GUIDComCat)
	Dim Binding
	Dim pProperty
	' walk each of the registered bindings for this component category
	for each Binding in Source.GetBindingManager.Bindings(GUIDComCat)
		' display the binding properties
		WScript.echo "    Binding " + Binding.ID + " {"
		WScript.echo "      DisplayName = " + Binding.DisplayName
		WScript.echo "      SinkClass = " + Binding.SinkClass

		' walk each of the source properties and display them
		WScript.echo "      SourceProperties {"
		for each pProperty in Binding.SourceProperties
			WScript.echo "        " + pProperty + " = " + Binding.SourceProperties.Item(pProperty)
		next
		WScript.echo "      }"

		' walk each of the sink properties and display them
		WScript.echo "      SinkProperties {"
		for each pProperty in Binding.SinkProperties
			WScript.echo "        " + pProperty + " = " + Binding.SinkProperties.Item(pProperty)
		next
		WScript.echo "      }"
		WScript.echo "    }"
	next
end sub

'
' dumps all of the information in the binding database related to NNTP
'
public sub DisplaySinks
	Dim SourceType
	Dim Source

	' look for each of the sources registered for the NNTP source type
	set SourceType = EventManager.SourceTypes(GUIDSourceType)
	for each Source in SourceType.Sources
		' display the source properties
		WScript.echo "Source " + Source.ID + " {"
		WScript.echo "  DisplayName = " + Source.DisplayName
		' display all of the sinks registered for the OnPost event
		WScript.echo "  OnPostEarly Sinks {"
		call DisplaySinksHelper(Source, GUIDComCatOnPostEarly)
		WScript.echo "  }"
		WScript.echo "  OnPost Sinks {"
		call DisplaySinksHelper(Source, GUIDComCatOnPost)
		WScript.echo "  }"
		' display all of the sinks registered for the OnPostFinal event
		WScript.echo "  OnPostFinal Sinks {"
		call DisplaySinksHelper(Source, GUIDComCatOnPostFinal)
		WScript.echo "  }"
		WScript.echo "}"
	next
end sub

' 
' display usage information for this script
'
public sub DisplayUsage
	WScript.echo "usage: cscript regfilt.vbs <command> <arguments>"
	WScript.echo "  commands:"
	WScript.echo "    /add <Instance> <Event> <DisplayName> <SinkClass> <Rule>"
	WScript.echo "    /remove <Instance> <Event> <DisplayName>"
	WScript.echo "    /setprop <Instance> <Event> <DisplayName> <PropertyBag> <PropertyName> "
	WScript.echo "             <PropertyValue>"
	WScript.echo "    /delprop <Instance> <Event> <DisplayName> <PropertyBag> <PropertyName>"
	WScript.echo "    /enum"
	WScript.echo "  arguments:"
	WScript.echo "    <Instance> is the NNTP instance to work against"
	WScript.echo "    <Event> can be OnPostEarly, OnPost or OnPostFinal"
	WScript.echo "    <DisplayName> is the display name of the event to edit"
	WScript.echo "    <SinkClass> is the sink class for the event"
	WScript.echo "    <Rule> is the rule to use for the event"
	WScript.echo "    <PropertyBag> can be Source or Sink"
	WScript.echo "    <PropertyName> is the name of the property to edit"
	WScript.echo "    <PropertyValue> is the value to assign to the property"
end sub


Dim iInstance
Dim szEvent
Dim szDisplayName
Dim szSinkClass
Dim szRule
Dim szPropertyBag
Dim szPropertyName
Dim szPropertyValue

'
' this is the main body of our script.  it reads the command line parameters
' specified and then calls the appropriate function to perform the operation
'
if WScript.Arguments.Count = 0 then
	call DisplayUsage
else 
	Select Case LCase(WScript.Arguments(0))
		Case "/add"
			iInstance = WScript.Arguments(1)
			szEvent = WScript.Arguments(2)
			szDisplayName = WScript.Arguments(3)
			szSinkClass = WScript.Arguments(4)
			szRule = WScript.Arguments(5)
			call RegisterSink(iInstance, szEvent, szDisplayName, szSinkClass, szRule)
		Case "/remove"
			iInstance = WScript.Arguments(1)
			szEvent = WScript.Arguments(2)
			szDisplayName = WScript.Arguments(3)
			call UnregisterSink(iInstance, szEvent, szDisplayName)		
		Case "/setprop"
			iInstance = WScript.Arguments(1)
			szEvent = WScript.Arguments(2)
			szDisplayName = WScript.Arguments(3)
			szPropertyBag = WScript.Arguments(4)
			szPropertyName = WScript.Arguments(5)
			szPropertyValue = WScript.Arguments(6)
			call EditProperty(iInstance, szEvent, szDisplayName, szPropertyBag, "add", szPropertyName, szPropertyValue)
		Case "/delprop"
			iInstance = WScript.Arguments(1)
			szEvent = WScript.Arguments(2)
			szDisplayName = WScript.Arguments(3)
			szPropertyBag = WScript.Arguments(4)
			szPropertyName = WScript.Arguments(5)
			call EditProperty(iInstance, szEvent, szDisplayName, szPropertyBag, "remove", szPropertyName, "")		
		Case "/dump"
			call DisplaySinks
		Case "/enum"
			call DisplaySinks
		Case Else
			call DisplayUsage
	End Select
end if
