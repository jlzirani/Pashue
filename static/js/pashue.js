
function length( obj ) 
{
	return Object.keys( obj ).length
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



angular.module('pashue', ["ngRoute"])
	.controller('pashue', function($scope, $rootScope, $route, $routeParams, $location) {
		$rootScope.$menu = [ { 	name: "dashboard",
							icon: "fas fa-home" },
						 { 	name: "lights",
							icon: "fas fa-lightbulb" },
						 { 	name: "groups",
							icon: "fas fa-lightbulb" } ];
		$rootScope.$active = 0;
	})
	.controller('groups', function($scope, $rootScope, $http) {
		var link = 'http://'+hue.ip+'/api/'+hue.user+'/';
		$rootScope.$active = "groups";
		$scope.data = {};
		
		$http.get(link+'lights')
			.then(function(response) {
				$scope.lights = response.data;
				$scope.info = {
					length: length(response.data),
					on: length( filterDict(response.data, 
						function( key, value) {
							return value.state.on; 
						})),
					reachable: length( filterDict(response.data, 
						function( key, value) {
							return value.state.reachable;
						}))
				}
			});
	})
	.controller('lights', function($scope, $rootScope, $http) {
		var link = 'http://'+hue.ip+'/api/'+hue.user+'/'; 

		$rootScope.$active = "lights";
		$scope.data = {};
		
		
		$http.get(link+'lights')
			.then(function(response) {
				$scope.lights = response.data;
				$scope.info = {
					length: length(response.data),
					on: length( filterDict(response.data, 
						function( key, value) {
							return value.state.on; 
						})),
					reachable: length( filterDict(response.data, 
						function( key, value) {
							return value.state.reachable;
						}))
				}
			});
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
				$scope.lights = {
					length: length(response.data),
					on: length( filterDict(response.data, 
						function( key, value) {
							return value.state.on; 
						})),
					reachable: length( filterDict(response.data, 
						function( key, value) {
							return value.state.reachable;
						}))
				}
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
			.when("/groups", {
				templateUrl: "/static/view/lights.html",
				controller: "groups"
			})

	});

