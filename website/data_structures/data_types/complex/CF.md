# (CF) Data Type - coded element with formatted values

As of v2.7 a third tuple, formerly known as triplet, has been added to the CF data type. Additionally, 3 new components were added to each tuple such that each tuple now has a total of 7 components. The Original Text component applies to the CF as a whole.

The Vocabulary TC is the steward of the CF data type.

This data type transmits codes and the formatted text associated with the code. This data type can be used to transmit for the first time the formatted text for the **canned text** portion of a report, for example, a standard radiological description for a normal chest X‑ray. The receiving system can store this information and in subsequent messages only the identifier need be sent. Another potential use of this data type is transmitting master file records that contain formatted text. This data type has six components as follows:

The components, primary and alternate, are defined exactly as in the CE data type with the exception of the second and fifth components, which are of the formatted text data type.

OBX||CF|71020^CXR^99CPMC||79989^\H\Description:\N\\.sp\\ti+4\Heart is not enlarged. There is no evidence of pneumonia, effusion, pneumothorax or any masses. \.sp+3\\H\Impression:\N\\.sp\\.ti+4\Negative chest.^99CPMC
