resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "properties" = {
            "conversationId" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = false,
        "properties" = {
            "emailAddress" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/conversations/$${input.conversationId}"
        headers = {
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\"emailAddress\": $${successTemplateUtils.firstFromArray($${emailAddress}, \"$esc.quote$esc.quote\")}}"
        translation_map = { 
			emailAddress = "$..EmailAddress"
		}
        translation_map_defaults = {       
			emailAddress = "[ \"\" ]"
		}
    }
}