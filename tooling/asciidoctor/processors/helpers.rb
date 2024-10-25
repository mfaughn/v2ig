module V2AsciidocterProcessorHelpers
    
  def is_hl7_er7(content)
    !!content.match(/^[A-Z]{2}[A-Z0-9]\|.*\|.*/)
  end
  
  def has_er7?(content)
    !!content.match(/[A-Z]{2}[A-Z0-9]\|.*\|/)
  end
  
  def has_message_identifier?(content)
    !!content.match(/^([A-Z]{3})\^[A-Z0-9]{3}\^(ACK|[A-Z]{3}_[A-Z0-9]{3})/)
  end
  
end