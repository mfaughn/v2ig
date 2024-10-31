# (OSP) Data Type - occurrence span code and date

A code and the related dates that identify an event that relates to the payment of the claim. For example, Prior Stay Dates which is the from/through dates given by the patient of any hospital stay that ended within 60 days of this hospital or SNF admission.

Replaces the CM data type used in section 6.5.11.8 UB2-8, as of v 2.5.

Use case: The patient was admitted for minor surgery (1/6/03) and discharged the following day (1/7/03). Complications ensured and the patient was readmitted the following day (1/8/03). When the claim for 1/8/03 is filed, the prior stay dates (1/6/03-1/7/03) must be reported (per the Health Plan) using Occurrence Span Code and Dates 71 - Prior Stay Date. Example:

|71&Prior Stay Date&NUBC\^20030106^20030107|
