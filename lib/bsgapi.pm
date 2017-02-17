use strict;
use utf8;
use LWP::UserAgent;
use JSON;

package BSGAPI;

my $urlApiPoint = 'https://app.bsg.hk/rest';

sub new {
	my $self = shift;
	my $apikey = shift;

	bless {
		'APIKEY' => $apikey,
	}, $self;

}

sub apikey {
	my $self = shift;
	my $newAPIKey = shift;
	if($newAPIKey){
		$self->{APIKEY} = $newAPIKey;
	}
	return $self->{APIKEY};
}

sub login {
	my $self = shift;
	my $newLogin = shift;
	if($newLogin){
		$self->{LOGIN} = $newLogin;
	}
	return $self->{LOGIN};
}

sub balance {
	my $self = shift;
	my $url = '/common/balance';
	return $self->send('GET', $url);
}

sub HLR {
	my $self = shift;
	my $url = '/hlr/';
	my ($reference ,$id) = @_;

	if(defined($id)) {
		$reference .='/';
	} 
	else {
		$id = $reference;
		$reference = '';
	}

	return 0 if(!$id);
	return $self->send('GET', $url.$reference.$id);
}

sub HLRCreate {
	my $self = shift;
	my $url = '/hlr/create';

	if(ref($_[0]) eq 'ARRAY'){

		my $content = JSON::to_json($_[0]);
		return $self->send('POST', $url, $content);
		return ;
	}

	my %params = @_;
	return 0 if(!int($params{msisdn}) || !length($params{reference}));

	return $self->send('POST', $url, \%params);

}

sub viber {
	my $self = shift;
	my $url = '/viber/';
	my ($type ,$id) = @_;

	if(defined($id)) {
		if(lc($type) eq 'id'){
			$type = '';
		}
		else {
			$type .='/';
		}
	} 
	else {
		$id = $type;
		$type = '';
	}

	return 0 if(!$id);
	return $self->send('GET', $url.$type.$id);
}

sub viberSend {
	my $self = shift;
	my %params = @_;
	my $url = '/viber/create';
	my @required = qw~to text alpha_name~;

	return 0 unless(exists($params{messages}) && ref($params{messages}) eq 'ARRAY');
	foreach my $message (@{$params{messages}}){
		foreach (@required){
			return 0 unless(exists($message->{$_}));	
		}
		return 0 unless (ref($message->{to}) eq 'ARRAY');
		foreach (@{$message->{to}}){
			return 0 unless(exists($_->{msisdn}) || exists($_->{reference}));
		}
	}
	return $self->send('POST', $url, JSON::to_json(\%params));
}


sub sms {
	my $self = shift;
	my $url = '/sms/';
	my ($type ,$id) = @_;

	if(defined($id)) {
		if(lc($type) eq 'id'){
			$type = '';
		}
		else {
			$type .='/';
		}
	} 
	else {
		$id = $type;
		$type = '';
	}

	return 0 if(!$id);
	return $self->send('GET', $url.$type.$id);
}

sub smsSend {
	my $self = shift;
	my %params = @_;
	my $url = '/sms/create';
	my @required = qw~destination originator body reference~;
	foreach (@required){
		return 0 unless(exists($params{$_}));
	}

	return 0 unless(exists($params{msisdn}) || exists($params{phones}));
	return $self->send('POST', $url, JSON::to_json(\%params));
}

sub price {
	my $self = shift;
	my @params = @_;
	my @types = qw~hrl sms viber~;

	unless(grep($params[0], @types)){
		return 0;
	}
	my $url = "/$params[0]/prices/".$params[1] || '';
	return $self->send('GET', $url);

}

sub last_error {
	my $self = shift;
	return $self->{LAST_ERROR};
}

sub send {
	my $self = shift;
	my $type = shift;
	my $method = lc($type);
	my $url = shift;
	my $form = shift;
	my $response;

	my $ua = new LWP::UserAgent;
	$ua->timeout(15);
	$ua->max_size(2*1048576);

	$ua->default_header('X-API-KEY' => $self->apikey);

	if($form && !ref($form)){
		my $request = HTTP::Request->new($type, $urlApiPoint.$url, ['Content-Type' => 'application/json']);
		$request->content($form);
		$response = $ua->request($request);
	}
	elsif($form) {
		$ua->default_header('Content-Type' => 'multipart/form-data');
		$response = $ua->$method($urlApiPoint.$url, $form);
	}
	else {
		$response = $ua->$method($urlApiPoint.$url);
	}

	if($response->is_success){
		return JSON::from_json($response->content);
	}
	else {
		my %err = (
			'error' => $response->code,
			'errorDescription' => $response->message
		);
		return \%err;
	}
}

1;