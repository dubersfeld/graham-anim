package com.dub.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class IndexController {
	
	@Value("${server.port}")
	int port;
		
	@Value("${server.servlet.context-path}")
	String path;	

    @RequestMapping({"/", "backHome"})
    public String index(ModelMap model) {

	String baseUrl = "http://localhost:" + port + path;
    	
    	model.addAttribute("baseUrl", baseUrl);
        return "convexHull/convexHull";
    }
}
