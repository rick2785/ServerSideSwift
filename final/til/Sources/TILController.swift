import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache

// Responsibility: call appropriate func & set header/body/completed

final class TILController {
  
  var routes: [Route] {
    return [
      Route(method: .get, uri: "/til", handler: indexView),
      Route(method: .post, uri: "/til", handler: addAcronym),
      Route(method: .post, uri: "/til/{id}/delete", handler: deleteAcronym)
    ]
  }

  // 1
  func indexView(request: HTTPRequest, response: HTTPResponse) {
    do {
      // 2
      var values = MustacheEvaluationContext.MapType()
      // 3
      values["acronyms"] = try AcronymAPI.allAsDictionary()
      // 4
      mustacheRequest(request: request, response: response, handler: MustacheHelper(values: values), templatePath: 
      request.documentRoot + "/index.mustache")
    } catch {
      // 5
      response.setBody(string: "Error handling request: \(error)")
        .completed(status: .internalServerError)
    }
  }

  func addAcronym(request: HTTPRequest, response: HTTPResponse) {
    do {
      // 1
      guard let short = request.param(name: "short"), let long = request.param(name: "long") else {
        response.completed(status: .badRequest)
        return
      }
      // 2
      _ = try AcronymAPI.newAcronym(withShort: short, long: long)
      // 3
      response.setHeader(.location, value: "/til")
        .completed(status: .movedPermanently)
    } catch {
      response.setBody(string: "Error handling request: \(error)")
        .completed(status: .internalServerError)
    }
  }

  func deleteAcronym(request: HTTPRequest, response: HTTPResponse) {
    do {
      // 1
      guard let idString = request.urlVariables["id"],
        let id = Int(idString) else {
        response.completed(status: .badRequest)
        return
      }
      // 2
      try AcronymAPI.delete(id: id)
      // 3
      response.setHeader(.location, value: "/til")
        .completed(status: .movedPermanently)
    } catch {
      response.setBody(string: "Error handling request: \(error)")
        .completed(status: .internalServerError)
    }
  }

}
