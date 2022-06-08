import React, { useState } from "react";

export default function ExperienceList({ experiences, path }) {
  const MAX_NUMBER_OF_EXPERIENCES = 3;

  function renderOption(experience) {
    return (
      <li>
        <div className="experience">
          <div className="experience__title">
             {experience.title} at {experience.company_name}
          </div>

          <div className="experience__date">
            {experience.date}
          </div>
        </div>
      </li>
    );
  };

  return (
    <>
      {experiences.slice(0, MAX_NUMBER_OF_EXPERIENCES).map(experience => renderOption(experience))}

      {experiences.length > MAX_NUMBER_OF_EXPERIENCES && (
        <a href={path} style={{ textDecoration: "underline" }}>+{experiences.length - MAX_NUMBER_OF_EXPERIENCES} more work experience{(experiences.length - MAX_NUMBER_OF_EXPERIENCES) === 1 ? "" : "s"}</a>
      )}
    </>
  )
};