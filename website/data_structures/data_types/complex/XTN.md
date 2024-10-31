# (XTN) Data Type - extended telecommunication number

1: A Work fax number

^WPN^FX^^^734^6777777

2: Telephone number with extension

^WPN^PH^^^734^6777777^1

2: Telephone number with internal code. In this example, assume that a corporation’s telephone system supports a full external telephone number (area code and telephone number). It also supports internal dialing standards that assign a code to each facility and an extension to each telephone (which happens to be the last 4 digits of the external telephone number, by convention).

**So, if the Los Angeles facility were assigned code 333, and if the "outside" telephone number at the LA office is (626) 555-1234, the components would be:**

|     |     |
| --- | --- |
| Component | Value |
| area/city code | 626 |
| phone number | 555-1234 |
| extension | 1234 |
| extension prefix | 333 |

The field would be transmitted as follows:

^WPN^PH^^^626^5551234^1234^333

**Example 3: speed dial. In this example, assume that a corporation’s telephone system supports speed dialing numbers. For example, suppose that a corporation has a contract with a travel agency, whose external number is 1-610-555-1234. Since it is so frequently dialed, the company assigns a speed code: #6098. The components would be:**

|     |     |
| --- | --- |
| Component | Value |
| Area/city code | 610 |
| Phone number | 555-1234 |
| Speed Dial | #6098 |

The field would be transmitted as follows:

^WPN^PH^^^610^5551234^^^#6098

**Example 4: home e-mail address. In this example, assume that a person has a primary home e-mail address such as someone@somewhere.com. The components would be:**

|     |     |
| --- | --- |
| Component | Value |
| Telecommunication Use Code | PRN |
| Telecommunication Equipment Type | Internet |
| Communication Address | someone@somewhere.com |

The field would be transmitted as follows:

^PRN^Internet^someone@somewhere.com

**Example 5: work e-mail address. In this example, assume that a person has a work e-mail address such as someone@somewhere.com. The components would be:**

|     |     |
| --- | --- |
| Component | Value |
| Telecommunication Use Code | WPN |
| Telecommunication Equipment Type | Internet |
| Communication Address | someone@somewhere.com |

The field would be transmitted as follows:

^WPN^Internet^someone@somewhere.com
