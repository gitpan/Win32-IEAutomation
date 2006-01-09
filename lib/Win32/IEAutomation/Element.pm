package Win32::IEAutomation::Element;

use strict;

sub new {
	my $class = shift;
	my $self  = { };
	$self->{element}   = undef;
	$self->{parent}    = undef;
	$self = bless ($self, $class);
	return $self;
}

sub getElement { 
	my $self = shift;
	return $self->{element};
}

sub getProperty{
	my ($self, $property) = shift;
	return $self->{element}->{$property};
}

sub linkText{
	my $self = shift;
	return $self->{element}->{outerText};
}

sub linkUrl{
	my $self = shift;
	return $self->{element}->{href};
}

sub imgUrl{
	my $self = shift;
	return $self->{element}->{src};
}

sub Click{
	my ($self, $nowait) = @_;
	$self->{element}->click;
	$self->{parent}->WaitforDone unless $nowait;
}

sub FireEvent{
	my ($self, $eventname) = @_;
	$self->{element}->fireEvent($eventname);
	$self->{parent}->WaitforDone;
}

sub Select{
	my $self = shift;
	unless ($self->{element}->{checked}){
		$self->{element}->{checked} = 1;
		$self->{element}->fireEvent("onclick");
		$self->{parent}->WaitforDone;
	}
}

sub deSelect{
	my $self = shift;
	if ($self->{element}->{checked}){
		$self->{element}->{checked} = 0;
		$self->{parent}->WaitforDone;
	}
}

sub SelectItem{
	my $self = shift;
	my @items = @_;
	foreach my $item (@items){
		my $options = $self->{element}->options;
		for (my $n =0; $n <= $options->length - 1; $n++){
			my $text = $options->item($n)->innerText;
			$text = trim_white_spaces($text);
			if ($text eq $item){
				$options->item($n)->{selected} = 1;
				$self->{element}->fireEvent("onchange");
				$self->WaitforDone;
				last;
			}
		}
	}
}

sub deSelectItem{
	my $self = shift;
	my @items = @_;
	foreach my $item (@items){
		my $options = $self->{element}->options;
		for (my $n =0; $n <= $options->length - 1; $n++){
			my $text = $options->item($n)->innerText;
			$text = trim_white_spaces($text);
			if ($text eq $item){
				$options->item($n)->{selected} = 0 if $options->item($n)->selected;
				$self->{element}->fireEvent("onchange");
				$self->WaitforDone;
				last;
			}
		}
	}
}

sub deSelectAll{
	my $self = shift;
	my @items = @_;
		my $options = $self->{element}->options;
		for (my $n =0; $n <= $options->length - 1; $n++){
				$options->item($n)->{selected} = 0 if $options->item($n)->selected;
				$self->{element}->fireEvent("onchange");
				$self->WaitforDone;
		}
}

sub SetValue{
	my ($self, $string) = @_;
	$self->{element}->{value} = $string;
}

sub ClearValue{
	my $self = shift;
	$self->{element}->{value} = "";
}

1;
__END__ 