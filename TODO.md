## TODO
- rename v2-vs-primitives to v2-vs-primitive-data-types.json ... do similar renames where appropriate

- put tabset stuff under [tabset] only if nothing there already

## ISSUES

- The visible HTML of the names of the types of complex data type components are getting rendered as their base type and not as the name of the actual type that they are.  Despite this, the hyperlink does go to the correct type.  For example, AD-6 reads as type "code" but the link goes correctly to type "ID".  We need the rendered string to be "ID".

- What to do in cases where a tabset has text between tables?  Example 8.9.1 and 8.11.1.  I don't think it happens elsewhere.  Nope, also in 15.3 and 5.4 with query/response stuff

- What do we do with the '...' segment in RSP_K11 (from 5.4.1)?
