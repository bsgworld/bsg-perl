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
                      
Example response

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

  Example response
                     
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
