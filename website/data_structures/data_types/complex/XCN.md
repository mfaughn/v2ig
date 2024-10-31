# (XCN) Data Type - extended composite ID number and name for persons

Replaces CN data type as of v 2.3.

This data type is used extensively appearing in the PV1, ORC, RXO, RXE, OBR and SCH segments, as well as others, where there is a need to specify the ID number and name of a person.

without assigning authority and assigning facility:

|1234567\^Everyman^Adam\^A^III\^DR^\^ADT01^\^L^4\^M11^MR|

s with assigning authority and assigning facility:

Dr. Harold Hippocrates’ provider ID was assigned by the Provider Master and was first issued at Good Health Hospital within the Community Health and Hospitals System. Since IS table values (first component of the HD) were not used for assigning authority and assigning facility, components 2 and 3 of the HD data type are populated and demoted to sub-components as follows:

12188^Hippocrates^Harold^H^IV^Dr^^^&Provider Master.Community Health and Hospitals&L^L^9^M10^DN^&Good Health Hospital.Community Health and Hospitals&L^A

Ludwig van Beethoven’s medical record number was assigned by the Master Patient Index and was first issued at Fairview Hospital within the University Hospitals System.

10535^van Beethoven&van^Ludwig^A^III^Dr^^^&MPI.Community Health and Hospitals&L^L^3^M10^MR^& Good Health Hospital.Community Health and Hospitals&L^A
