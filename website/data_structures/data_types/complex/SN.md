# (SN) Data Type - structured numeric

The structured numeric data type is used to unambiguously express numeric clinical results along with qualifications. This enables receiving systems to store the components separately, and facilitates the use of numeric database queries. The corresponding sets of values indicated with the &lt;comparator> and &lt;separator/suffix> components are intended to be the authoritative and complete set of values. If additional values are needed for the &lt;comparator> and &lt;separator/suffix> components, they should be submitted to HL7 for inclusion in the Standard.

If &lt;num1> and &lt;num2> are both non-null, then the separator/suffix must be non-null. If the separator is "-", the data range is inclusive; e.g., &lt;num1> - &lt;num2> defines a range of numbers x, such that: &lt;num1> &lt;=x&lt;= &lt;num2>.
