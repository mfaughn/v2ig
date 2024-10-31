# (RFR) Data Type - reference range

Describes a reference range and its supporting detail.

Replaces the CM data type used in sections 8.8.4.6 - OM2-6, 8.8.4.7 - OM2-7 and 8.8.4.8 - OM2-8 as of v 2.5.

s:

a) A range that applies unconditionally, such as albumin, is transmitted as:

|3.0&5.5|

b) A normal range that depends on sex, such as Hgb, is transmitted as:

|13.5&18\^M~12.0 & 16^F|

c) A normal range that depends on age, sex, and race (a concocted example) is:

|10&13\^M^0&2\^^\^B11&13.5^M\^2&20^\^^B~12&14.5\^M^20&70\^^\^B~13&16.0^M\^70&^\^^B|

When no value is specified for a particular component, the range given applies to all categories of that component. For example, when nothing is specified for race/species, the range should be taken as the human range without regard to race. If no age range is specified, the normal range given is assumed to apply to all ages.
