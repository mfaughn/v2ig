# (PL) Data Type - person location

This data type is used to specify a patient location within a healthcare institution. Which components are valued depends on the needs of the site. For example for a patient treated at home, only the person location type is valued. It is most commonly used for specifying patient locations, but may refer to other types of locations within a healthcare setting.

This data type contains several location identifiers that should be thought of in the following order from the most general to the most specific: facility, building, floor, point of care, room, bed.\
Additional data about any location defined by these components can be added in the following components: person location type, location description and location status.

Nursing Unit

A nursing unit at Community Hospital: 4 East, room 136, bed B

4E^136^B^CommunityHospital^^N^^^

Clinic

A clinic at University Hospitals: Internal Medicine Clinic located in the Briones building, 3^rd^ floor.

InternalMedicine^^^UniversityHospitals^^C^Briones^3^

Home

The patient was treated at his home.

^^^^^H^^^
