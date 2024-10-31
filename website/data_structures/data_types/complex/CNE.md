# (CNE) Data Type - coded with no exceptions

As of v2.7 a third tuple, formerly known as triplet, has been added to the CNE data type. Additionally, 3 new components were added to each tuple such that each tuple now has a total of 7 components. The Original Text component applies to the CNE as a whole.

The Vocabulary TC is the steward of the CNE data type.

Specifies a coded element and its associated detail. The CNE data type is used when a required or mandatory coded field is needed. The specified HL7 table or imported or externally defined coding system must be used and may not be extended with local values. Text may not replace the code. A CNE field must have an HL7 defined or external table associated with it. A CNE field may be context sensitive such that a choice of explicit coding systems might be designated. This allows for realm and other types of specificity. Every effort will be made to enumerate the valid coding system(s) to be specified in the 3rd component, however, the standards body realizes that this is impossible to fully enumerate.

The presence of two sets of equivalent codes in this data type is semantically different from a repetition of a CNE-type field. With repetition, several distinct codes (with distinct meanings) may be transmitted.

1: The drug must be coded and must be taken from the specified coding system. The coding system is an external coding system. Example is derived from _FT1-26_.

|0006-0106-58\^Prinivil 10mg oral tablet^NDC|

2: Consent mode must be coded and must be taken from the specified coding system. The coding system is an HL7 code table. Example is taken from _CON-10_.

|V\^Verbal^HL70497\^^\^^2.8|
