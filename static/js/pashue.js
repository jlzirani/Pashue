
function length( obj ) 
{
	return (obj === null || obj === undefined) ? 0 : Object.keys( obj ).length
}

function filterDict( dict, testFn )
{
	let value = {}
	for( var key in dict ) {
		if( testFn(key, dict[key]) )
			value[key] = dict[key];
	}
	return value;
}

function iterApply(dict, fn )
{
	for( var key in dict ) {
		fn(dict[key]);
	}	
}

var pashueModule = angular.module('pashue', ["ngRoute"])
	.filter('getStateLamp', function() {
		return function(obj,tgt) {
			return filterDict(obj, function( _k, val ) {
				return val.state[tgt];
			})
		}
	})
	.filter('objLength', function() {
		return length;
	})
	.controller('pashue', function($scope, $rootScope, $route, $routeParams, $location) {
		$rootScope.$menu = [ { 	name: "dashboard",
							icon: "fas fa-home" },
						 { 	name: "lights",
							icon: "fas fa-lightbulb" }];
		$rootScope.$active = 0;
	})
	.controller('dashboard', function($scope,$rootScope, $http) {
		var link = 'http://'+hue.ip+'/api/'+hue.user+'/'; 
		
		$rootScope.$active = "dashboard";
						
		$http.get(link + 'config')
			.then(function(response) {
				$scope.config = response.data;
			});
		$http.get(link+'lights')
			.then(function(response) {
				$scope.lights = response.data;
			});
	})
	.config(function($routeProvider) {
		$routeProvider
			.when("/", {
				templateUrl: "/static/view/dashboard.html",
				controller: 'dashboard',
			})
			.when("/dashboard", {
				templateUrl: "/static/view/dashboard.html",
				controller: "dashboard"
			})
			.when("/lights", {
				templateUrl: "/static/view/lights.html",
				controller: "lights"
			})
			.when("/light/:id", {
				templateUrl: "/static/view/light.html",
				controller: "light"
			})
	});
	
// Lights
pashueModule.controller('lights', function($scope, $rootScope, $http, $log) {
		var link = 'http://'+hue.ip+'/api/'+hue.user+'/lights'; 
		$rootScope.$active = "lights";
	
		$scope.setFn = function(id, action) {
			$http.put(link+"/"+id+"/state", JSON.stringify({"on": action}))
				.then(function(response) {});
		};
		
		$scope.setAllFn = function(action) {
			$http.put('http://'+hue.ip+'/api/'+hue.user+'/groups/0/action',
						{"on": action } )
				.then(function(response) {
						iterApply($scope.lights, function( val ) {
							val.state.on = action;
						})
				})
		}
			
		$http.get(link)
			.then(function(response) {
				$scope.lights = response.data;
			});
			
	})
	.controller('light', function($scope, $rootScope, $http, $routeParams) {
		var link = 'http://'+hue.ip+'/api/'+hue.user+'/lights/'+$routeParams.id; 

		$rootScope.$active = "lights";
				
		$scope.setBri = function() {
			$http.put(link+"/state", JSON.stringify({"bri": parseInt($scope.light.state.bri)}))
				.then(function(response) {});
			
		}
		
		$scope.setOnOffFn = function(action) {
			$http.put(link+"/state", JSON.stringify({"on": action}))
				.then(function(response) {});
		};
				
		$http.get(link)
			.then(function(response) {
				$scope.light = response.data;
			});
	});
