import React, {
  useRef,
  useState
} from "react";
import useDidMountEffect from "hooks/useDidMountEffect";

import LocationOption from "./LocationOption";

export default function LocationOptions({ name,
                                          existingSelectedLocations }) {
  const [selectedLocations, setSelectedLocations] = useState(existingSelectedLocations);

  function handleCheckChange(selectedLocation, event) {
    // Don't need to check if checkbox is checked because it can only be unchecked or else
    // it no longer appears in the interface in the first place
    const newSelectedLocations = selectedLocations.slice();

    newSelectedLocations.splice(newSelectedLocations.indexOf(selectedLocation), 1);

    setSelectedLocations(newSelectedLocations);
  };

  function handleRadiusChange(selectedLocation, newRadius) {
    const newSelectedLocations = selectedLocations.map((nestedSelectedOption) => {
      if (nestedSelectedOption.location === selectedLocation.location) {
        console.log("Setting radius to", newRadius)
        return {
          "location": selectedLocation.location,
          "radius": newRadius
        };
      } else {
        return nestedSelectedOption;
      }
    });

    setSelectedLocations(newSelectedLocations);
  };

  function handleResetClick(selectedLocation, event) {
    const newSelectedLocations = selectedLocations.map((nestedSelectedOption) => {
      if (nestedSelectedOption.location === selectedLocation.location) {
        // Remove radius key
        return {
          "location": selectedLocation.location
        };
      } else {
        return nestedSelectedOption;
      }
    });

    console.log(newSelectedLocations[0])

    setSelectedLocations(newSelectedLocations);
  };

  function renderSelectedLocation(selectedLocation) {
    console.log("Re-rendering", selectedLocation)
    return (
      <LocationOption name={name}
                      selectedLocation={selectedLocation}
                      onCheckChange={handleCheckChange.bind(null, selectedLocation)}
                      onRadiusChange={handleRadiusChange.bind(null, selectedLocation)}
                      onResetClick={handleResetClick.bind(null, selectedLocation)} />
    );
  };

  useDidMountEffect(() => {
    const event = new Event("liveFormController.apply");

    document.dispatchEvent(event);
  }, [selectedLocations]);

  return (
    <>
      {selectedLocations.map(renderSelectedLocation)}

      <div data-controller="location-autocomplete"
           data-action="google-maps-ready@window->location-autocomplete#init"
           className="field">
        <input type="text"
               name={`${name}[][location]`}
               autoComplete="off"
               placeholder="Search by location"
               data-location-autocomplete-target="input"
               data-action="location-selected->live-form#apply" />
      </div>
    </>
  )
};