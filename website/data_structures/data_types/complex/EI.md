# (EI) Data Type - entity identifier

The entity identifier defines a given entity within a specified series of identifiers.

The EI is appropriate for, but not limited to, machine or software generated identifiers. The generated identifier goes in the first component. The remaining components, 2 through 4, are known as the assigning authority; they identify the machine/system responsible for generating the identifier in component 1.

The specified series, the assigning authority, is defined by components 2 through 4. The assigning authority is of the hierarchic designator (HD) data type, but it is defined as three separate components in the EI data type, rather than as a single component as would normally be the case. This is in order to maintain backward compatibility with the EI’s use as a component in several existing data fields. Otherwise, the components 2 through 4 are as defined in Section _2A.2.33_, "_HD - hierarchic designator_". Hierarchic designators (HD) are unique across a given HL7 implementation.
