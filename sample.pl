#!/usr/bin/perl

use strict;
use Data::Dumper;

use BSGAPI;

my $apikey = 'test_8zWaPwOaHDPRFmgIldhl';

my $api = new BSGAPI($apikey);

print Dumper($api->balance());

print Dumper($api->HLRCreate('msisdn'=>'380972920000', 'reference'=>'extid1'));


print Dumper($api->HLRCreate(
      [ 
        {
          "msisdn"=>"380972920000",
          "reference"=>"extid1",
          "tariff"=>"0",
          "callback_url"=>"http://someurl.com/callback/?id=12345"
        },
        {
          "msisdn"=>"380972920000",
          "reference"=>"extid2",
          "tariff"=>"0",
          "callback_url"=>"http://someurl.com/callback/?id=12346"
        }
      ]
));

print Dumper($api->HLR(2));

print Dumper($api->HLR('reference'=>'380972920000'));


print Dumper($api->price('hlr'));
print Dumper($api->price('sms'));
print Dumper($api->price('viber'=>1));

print Dumper($api->sms(174044));
print Dumper($api->sms("task"=>17));
print Dumper($api->sms("reference"=>"ext_id_17"));

print Dumper($api->smsSend("destination"=>"phone",
                          "originator"=>"alpha name",
                          "body"=>"message text",
                          "msisdn"=>"380972000000",
                          "reference"=>"ext_id_16",
                          "validity"=>"1",
                          "tariff"=>"0"
));

print Dumper($api->smsSend("destination"=>"phones",
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
                          ]
));

print Dumper($api->viber(174044));

print Dumper($api->viberSend("tariff"=>"0",
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
                        ]

));

