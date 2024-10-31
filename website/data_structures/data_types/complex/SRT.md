# (SRT) Data Type - sort order

Specifies those parameters by which the response will be sorted and by what method.

In a tabular response query, where the return data is known by column name, the SRT might look like:

|LastName\^A~FirstName^A|

In a segment response query, where the return data is known by segment and offset, the SRT field would use segment field name notation:

|PID.3.1\^A~PID.3.2^A|
