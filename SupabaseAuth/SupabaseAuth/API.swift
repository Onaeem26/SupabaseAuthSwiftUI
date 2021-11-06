//
//  API.swift
//  SupabaseAuth
//
//  Created by Muhammad Osama Naeem on 11/6/21.
//

import Foundation
import Supabase
class API {
    static var supabaseServiceKey = ""
    static var supabaseURL = ""

    static var supabase = SupabaseClient(supabaseUrl: API.supabaseURL, supabaseKey: API.supabaseServiceKey)
}
