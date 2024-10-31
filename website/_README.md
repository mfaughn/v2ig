Please refer to this webpage for guidance on authoring using AsciiDoc: https://docs.asciidoctor.org/asciidoc/latest/syntax-quick-reference/

The directories in the 'website' directory do not define the structure of the website from the standpoint of the user.  They do serve as a convenient aid to help authors find content that needs to be edited.  The also dictate the structure of the output html, which means that linked files adhere to this directory structure.  The actual structure of the website is defined by the links and inclusions found in the .adoc files found within the 'website' directory and its subdirectories. *NOTE*: whitespace is not allowed in the names of directories.  Please use underscore characters instead of whitespace characters.

The content here will be processed into content suitable for use by the FHIR IG Publisher.

Things to detail:
- general asciidoc: paragraphs, whitespace, comments, parameters
- footnotes
- er7 (automatic linebreaks)
- document attributes
  - :sectnums:
  - :example-caption!:
  

Questions:
- Should the links to tech_specs really not include the event(s) identifiers??

Possibilities
- It would be possible to automatically build Tabsets based on a single trigger message.  Do this by recursively traversing all Ack Chors until you are down to just Ack Chors for ACK messages or there are no other messages. This would require that all tabsets that were automatically built be built the same way. This could be overridden by, e.g., passing parameters to a tabset or creating a [custom-tabset] block.
  - We could also build sequence diagrams from the same sort of information...