package com.controller;
import java.sql.Connection;
import java.sql.DriverManager;

public class Connect {
	static Connection connect; 
	public static Connection getConnection()
    {
        try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		connect=DriverManager.getConnection("jdbc:mysql://localhost:3306/tasktracking", "root", "2003");
        }
        catch (Exception e) {
            System.out.println("Connection Failed!");
        }
		return connect;
    }
        

		
	}


