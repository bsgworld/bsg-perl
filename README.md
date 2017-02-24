# bsg-perl
This repository contains the open source Perl client for BSG's REST API.

## API function "balance"
BSG provides an API to get the balance information of your account.

    #!/usr/bin/perl
    use BSGAPI;
    
    my $apikey = 'test_8zWaPwOaHDPRFmgIldhl';
    my $api = new BSGAPI($apikey);
    
    my $balance = $api->balance();

#### Simple response

    $balance = {
      "error":0,
      "errorDescription":"No errors",
      "amount":"-0.2800005",
      "currency":"EUR",
      "limit":"10"
    }

## API function "HLRCreate"

 Number Lookup helps you keep your mobile numbers database up to date.

 Mobile subscribers often change numbers, go into roaming and change providers while retaining their original phone number. Knowing which mobile numbers are in use and available, or which network your client is currently using can greatly improve accuracy and cost effectiveness for many types of businesses.
 With Number Lookup, you can determine:

 - which numbers are currently active
 - is the mobile number in roaming
 - is the mobile number ported

**Parameters**
>   **msisdn**          *(int)*     The telephone number. Required.
>   
>   **reference**       *(string)*   A client reference. Required.
>   
>   **tariff**          *(int)*     Tariff code of a price grid.
>   
>   **callback_url**    *(string)*  The URL on your call back server on which the   Number Lookup response will be sent.

#### Single HLR request:

    my $response = $api->HLRCreate('msisdn'=>'380972920000', 'reference'=>'extid1');
                      
Example response:

       $response = {
            "result":
              [
                {
                  "error":0,
                  "msisdn":"380972920000",
                  "reference":"ext_id_15",
                  "tariff_code":"0",
                  "callback_url":"http://someurl.com/callback",
                  "price":0.02,
                  "currency":"EUR",
                  "id":"212"
                }
              ],
            "total_price":0.02,
            "currency":"EUR"
          }

#### Multiple:

    $response = $api->HLRCreate(
          [ 
            {
              "msisdn"=>"380972920000",
              "reference"=>"extid1",
              "tariff"=>"0",
              "callback_url"=>"http://someurl.com/callback/?id=12345"
            },
            {
              "msisdn"=>"380972920002",
              "reference"=>"extid2",
              "tariff"=>"0",
              "callback_url"=>"http://someurl.com/callback/?id=12346"
            }
          ]
    )

  Example response:
                     
    $response = { "result":
       [
         {
           "reference":"extid1",
           "id":"1",
           "error":"0",
           "price":"0.002",
           "currency":"EUR"
         },
         {
           "reference":"extid2",
           "id":"2",
           "error":"0",
           "price":"0.002",
           "currency":"EUR"
         }
       ],
     "error":"0",
     "totalprice":"0.004",
     "currency":"EUR"
     }

## API function "HLR"

Retrieves the information of an existing HLR. You only need to supply the unique message id that was returned upon creation or receiving.

	$response = $api->HLR(2); # HLR id
	# or
	$response = $api->HLR('reference'=>'ext_id_14'); # by reference

Example response:

	$response = {
                        "error":0,
                        "errorDescription":"No errors",
                        "name_ru":"Украина",
                        "name_en":"Ukraine",
                        "brand":"Kyivstar",
                        "name":"Kyivstar GSM JSC",
                        "msisdn":"380972920001",
                        "id":"380972920001",
                        "reference":"ext_id_14",
                        "network":"25503",
                        "status":"sent",
                        "details":
                          { 
                            "imsi":"380970000000",
                            "ported":"0",
                            "roaming":"0"
                          },
                        "createdDatetime":"2017-01-17T08:53:08+00:00",
                        "statusDatetime":"2017-01-17T08:53:08+00:00"
                      }
                      
## SMS message

  BSG provides an API to send SMS messages to any country across the world. 

  BSG are identified by a unique random ID. And with this ID you can always check the status of the message through the provided endpoint.

### Send a SMS message

Creates a new message object. BSG returns the created message object with each request. Per request, a max of 50 phones can be entered.

**Parameters**
> **destination**           *(string)* The type of message campaign. Required
> Values can be: 
> - phone  (single message reuest).
> - phones (multiple message reuest).

>  **originator**   *(string)* The sender of the message. This can be a telephone number 
> (including country code) or an alphanumeric string. In case of an alphanumeric string, the maximum length is 11 characters. Required

> **body**  *(string)* The body of the SMS message. Required

> **msisdn**  *(string)* The telephone number. Required

> **reference** *(string)* A client reference. Required

> **phones**  *(array)* The array of recipients msisdn's & reference's. Required
>                      Set only for multiple message request ("destination": "phones").

> **validity**  *(int)* The amount of seconds that the message is valid.

> **tariff**  *(int)* Tariff code of a price grid.

	# SIngle sms
	$response = $api->smsSend("destination"=>"phone",
		                  "originator"=>"alpha name",
		                  "body"=>"message text",
		                  "msisdn"=>"380972000000",
		                  "reference"=>"ext_id_16",
		                  "validity"=>"1",
		                  "tariff"=>"0");
	
	#  Multitiple sms
	$response = $api->smsSend("destination"=>"phones",
                          "originator"=>"alpha name",
                          "body"=>"message text",
                          "reference"=>"ext_id_16",
                          "validity"=>"1",
                          "tariff"=>"0",
                          "phones"=>[
	                          { 
	                            "msisdn"=>"380972000000",
	                            "reference"=>"ext_id_17"
	                          },
	                          {
	                            "msisdn"=>"380972000001",
	                            "reference"=>"ext_id_18"
	                          }
                          ]);

Example response:

      # SINGLE MESSAGE
      {
        "result":{
          "error":0,
          "errorDescription":"No errors",
          "reference":"ext_id_16",
          "id":"213",
          "price":0.23,
          "currency":"EUR"
        } 
      }

    # MULTIPLE MESSAGES
      {
        "task_id":"6",
        "result":[
          {
            "error":0,
            "errorDescription":"No errors",
            "reference":"ext_id_17",
            "id":"214",
            "price":0.23,
            "currency":"EUR"
          },
          {
            "error":0,
            "errorDescription":"No errors",
            "reference":"ext_id_18",
            "id":"215",
            "price":0.23,
            "currency":"EUR"
          }
        ],
          "total_price":0.46,
          "currency":"EUR"
      }

### View a status

	# by SMS ID
	$response = $api->sms(214);
	# by task ID
	$response = $api->sms("task"=>6);
	# by reference 
	$response = $api->sms("reference"=>"ext_id_17");
	
Example response:

     # SINGLE SMS RESPONSE
      {
        "error":0,
        "errorDescription":"No errors",
        "id":"211",
        "msisdn":"380972000001",
        "reference":"ext_id_19",
        "time_in":"2017-01-17 09:11:41",
        "time_sent":"2017-01-17 09:11:41",
        "time_dr":"2017-01-17 09:11:41",
        "status":"delivered",
        "price":0.23,
        "currency":"EUR"
      }
      
      #TASK SMS RESPONSE
      
      {
        "originator":"alpha_name",
        "body":"message text",
        "validity":72,
        "totalprice":0.23,
        "currency":"EUR",
        "sent":1,
        "delivered":1,
        "expired":0,
        "undeliverable":0,
        "unknown":0
      }


## Viber message

VIBER provides an API to send VIBER messages to any country across the world.

BSG are identified by a unique random ID. And with this ID you can always check the status of the message through the provided endpoint.

### Send message

Send a VIBER message

Creates a new message object. BSG returns the created message object with each request. Per request, a max of 50 phones can be entered.


**Parameters**

> **messages**  *(array)* The array of VIBER message objects.  Required

> **to** *(array)* The array of recipients msisdn's & reference's.  Required

> **msisdn**  *(string)*  The telephone number.  Required

> **reference**   *(string)*  A client reference.  Required

> **text**  *(string)* The body of the VIBER message.  Required

> **alpha_name**  *(string)*  The sender of the message.  Required

> **validity**  *(int)*  The amount of seconds that the message is valid.

> **tariff**  *(int)*  Tariff code of a price grid.

> **reference**  *(string)* A client reference.

> **options**:  *(hash)* An hash with VIBER options.



	$response = $api->viberSend("tariff"=>"0",
        "validity"=>"1",
        "messages"=>[
          {
            "to"=>[
              {
                "msisdn"=>"380973973859",
                "reference"=>"ext_id_19"
              }
            ],
            "text"=>"My Viber messages is shinier than your SMS messages",
            "alpha_name"=>"BSG",
            "is_promotional"=>0,
            "options"=>{
              "viber"=>{
                "img"=>"http://mysite.com/logo.png",
                "caption"=>"See Details",
                "action"=>"http://mysite.com/"
              }
            }
          }
        ]);

Example response:

      {
        "result":[
          {
            "error":0,
            "errorDescription":"No errors",
            "reference":"ext_id_19",
            "id":"217",
            "price":0.23,
            "currency":"EUR"
          }
        ],
        "currency":"EUR",
        "total_price":0.23
      }

     # IN ERROR CASE
      {
        "result":[
          {
            "error":43,
            "errorDescription":"External ID already exists",
            "reference":"ext_id_19"
          }
        ]
      }
      
### View a status

Retrieves the information of an existing message. This message can be a sent or a received message. You only need to supply the unique message id that was returned upon creation or receiving.

	$response = $api->viber('380972920000');
	# or by reference
	$response = $api->viber("reference"=>"ext_id_19");

Example response:

      {
        "error":0,
        "errorDescription":"No errors",
        "id":"380972920000",
        "msisdn":"380972920000",
        "reference":"ext_id_19",
        "time_in":"2017-01-17 09:20:02",
        "time_sent":"2017-01-17 09:20:02",
        "time_dr":"2017-01-17 09:20:02",
        "status":"read",
        "price":0.23,
        "currency":"EUR"
      }


## Price

BSG provides an API to get the price information of your account.

	$response = $api->price('hlr');
	$response = $api->price('sms');
	$response = $api->price('viber'=>1);






























///////