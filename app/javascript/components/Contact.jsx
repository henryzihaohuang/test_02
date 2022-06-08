import React, { useState } from "react";

import APIClient from "lib/APIClient";
import CopyToClipboard from "components/CopyToClipboard";

export default function({ authToken, candidateId }) {
  const [requested, setRequested] = useState(false);
  const [contactInformation, setContactInformation] = useState({ email: null, linkedInURL: null });

  async function handleContactClick(event) {
    event.preventDefault();

    const { email, linkedInURL } = await APIClient.getCandidateContactInformation(authToken, candidateId);

    setRequested(true);
    setContactInformation({
      email: email,
      linkedInURL: linkedInURL
    });
  };

  return requested ? (
    <div>
      <div className="attribute">
        <div className="attribute__name">Email</div>

        <CopyToClipboard body={contactInformation.email} />
      </div>

      <div className="attribute">
        <div className="attribute__name">LinkedIn</div>

        <CopyToClipboard body={contactInformation.linkedInURL} />
      </div>
    </div>
  ) : (
    <a onClick={handleContactClick}
       className="button button--small">Contact</a>
  );
};