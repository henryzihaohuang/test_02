import Pipeline from "models/Pipeline";

class APIClient {
  static request = async ({ path, method, authToken, body }) => {
    const fetchArguments = {
      method: method,
      headers: {
        "Accept": "application/json"
      }
    };

    if (["POST", "PUT", "PATCH"].includes(method)) {
      fetchArguments["headers"]["Content-Type"] = "application/json";
    };

    if (authToken) {
      fetchArguments["headers"]["X-Auth-Token"] = authToken;
    };

    if (body) {
      fetchArguments["body"] = JSON.stringify(body);
    };

    return fetch(`/api${path}`, fetchArguments);
  };

  static getPipelines = async (authToken) => {
    let url = "/pipelines";

    const response = await APIClient.request({
      path: url,
      method: "GET",
      authToken
    });
    const responseJSON = await response.json();

    return responseJSON;
  };

  static createPipeline = async (authToken, name) => {
    let url = `/pipelines`;

    const response = await APIClient.request({
      path: url,
      method: "POST",
      authToken,
      body: {
        pipeline: {
          name: name
        }
      }
    });
    const responseJSON = await response.json();

    return JSONToPipeline(responseJSON);
  };

  static saveToPipeline = (authToken, candidateId, pipelineId) => {
    let url = `/candidates/${candidateId}/save`;

    APIClient.request({
      path: url,
      method: "POST",
      authToken,
      body: {
        pipeline_id: pipelineId
      }
    });
  };

  static updateSavedCandidate = async (authToken, savedCandidateId, { resume, assessment, status }) => {
    let url = `/saved_candidates/${savedCandidateId}`;

    await APIClient.request({
      path: url,
      method: "PATCH",
      authToken,
      body: {
        saved_candidate: {
          resume,
          assessment,
          status
        }
      }
    });
  };

  static getCandidateContactInformation = async (authToken, candidateId) => {
    let url = `/candidates/${candidateId}/contact`;

    const response = await APIClient.request({
      path: url,
      method: "POST",
      authToken
    });
    const responseJSON = await response.json();

    return {
      email: responseJSON.email,
      linkedInURL: responseJSON.linked_in_url
    };
  };

  static trackAppSession = (authToken, duration) => {
    let url = `/app_sessions`;

    APIClient.request({
      path: url,
      method: "POST",
      authToken,
      body: {
        app_session: {
          duration: duration
        }
      }
    });
  };
};

function JSONToPipeline(JSON) {
  return new Pipeline(JSON.id, JSON.name, JSON.number_of_candidates, JSON.created_at_date);
};

export default APIClient;