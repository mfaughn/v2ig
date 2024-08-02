# HL7 v2+ Specification

This IG is in development and is not yet production ready.  It is not expected to successfully build using IG publisher.

Most, if not all, of the textual portions of the v2+ specification are captured as AsciiDoc.  This text is found in the `website` directory.  While the _exact_details are still being worked out, it is expected that building the v2+ IG will require a substantial preprocessing step that generates files appropriate for IG Publisher input.  This will include conversion of AsciiDoc into HTML and/or Markdown.  The converted text will be distributed to appropriate IG input files.

The `inputs/sourcOfTruth` directory contains FHIR structure definitions that define the v2+ data structures.  These include data types, segment definitions, message structures, messages, events, and acknowledgement choreographies.  At least initially, the text associated with these definitional elements will be maintained as AsciiDoc which will be programmatically inserted into the StructureDefinitions.

Discussion about the v2+ IG are welcomed.  Please feel free to use the Discussions feature of this GitHub repository.

### AsciiDoc
AsciiDoc is a much more powerful and full-featured markup solution than Markdown.  AsciiDoc allows you to do all of the  things that Markdown allows you to do in a manner that is about is simple as Markdown using a very similar syntax.  While becoming an expert in all of the things that AsciiDoc can do would be a significant undertaking, you can make good use of AsciiDoc by becoming familiar with just the basics.

Here are some sources for learning about how to author documents using AsciiDoc:
- [AsciiDoc Syntax Quick Reference](https://docs.asciidoctor.org/asciidoc/latest/syntax-quick-reference/) - this should be all you need most of the time.  There are many other cheat sheets and AsciiDoc introductions available on the web as well.
- [AsciiDoc Language Documentation](https://docs.asciidoctor.org/asciidoc/latest/) - in the event that the Quick Reference doesn't have what you need...

<br>
<br>
<br>
<br>
<br>
Ironically, this page is written in Markdown..
