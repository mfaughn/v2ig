# HL7 v2+ Specification

This IG is in development and is not yet production ready.  It is not expected to successfully build using IG publisher.

Most, if not all, of the textual portions of the v2+ specification are captured as AsciiDoc.  This text is found in the `website` directory.  While the _exact_details are still being worked out, it is expected that building the v2+ IG will require a substantial preprocessing step that generates files appropriate for IG Publisher input.  This will include conversion of AsciiDoc into HTML and/or Markdown.  The converted text will be distributed to appropriate IG input files.

The `inputs/sourcOfTruth` directory contains FHIR structure definitions that define the v2+ data structures.  These include data types, segment definitions, message structures, messages, events, and acknowledgement choreographies.  At least initially, the text associated with these definitional elements will be maintained as AsciiDoc which will be programmatically inserted into the StructureDefinitions.

Discussion about the v2+ IG are welcomed.  Please feel free to use the Discussions feature of this GitHub repository.
