import React, { useState } from "react";

import Select from "react-select";

export default function LocationOption({ name, selectedLocation, onCheckChange, onRadiusChange, onResetClick }) {
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const radiusOptions = [
    { label: "5 miles", value: 5 },
    { label: "10 miles", value: 10 },
    { label: "20 miles", value: 20 },
    { label: "30 miles", value: 30 },
    { label: "40 miles", value: 40 },
    { label: "50 miles", value: 50 }
  ];

  function handleSetRadiusClick(event) {
    event.preventDefault();

    setDropdownOpen(!dropdownOpen);
  };

  function handleRadiusChange(data) {
    onRadiusChange(data.value);
  };

  function handleInputChange() {
    setDropdownOpen(false);
  };

  function getRadiusOption(value) {
    return radiusOptions.find(radiusOption => radiusOption.value === value);
  };

  return (
    <div>
      <div className="checkbox checkbox--flex">
        <input type="checkbox"
               name={`${name}[][location]`}
               value={selectedLocation.location}
               checked={true}
               onChange={onCheckChange}
               autoComplete="off" />

        <div className="checkbox--flex__details">
          <div style={{ "flexGrow": 1 }}>
            <label style={{"display": "block", "marginBottom": "5px"}}>
              {selectedLocation.location}
            </label>

            <a href="javascript:void(0);" onClick={handleSetRadiusClick}>
              {selectedLocation.radius ? `${selectedLocation.radius} mile radius` : "Set radius"}
            </a>

            <Select name={`${name}[][radius]`}
                    options={radiusOptions}
                    defaultValue={selectedLocation.radius ? getRadiusOption(parseInt(selectedLocation.radius)) : null}
                    value={selectedLocation.radius ? getRadiusOption(parseInt(selectedLocation.radius)) : null}
                    menuIsOpen={dropdownOpen}
                    onChange={handleRadiusChange}
                    onInputChange={handleInputChange}
                    styles={{
                      control: (styles) => {
                        return {
                          ...styles,
                          display: "none"
                        };
                      },
                      menu: (styles) => {
                        return {
                          ...styles,
                          borderRadius: "1px"
                        }
                      },
                      menuList: (styles) => {
                        return {
                          ...styles,
                          paddingTop: 0,
                          paddingBottom: 0
                        }
                      }
                    }} />
          </div>

          {selectedLocation.radius && (
            <a href="javascript:void(0);"
               onClick={onResetClick}
               className="danger">Reset</a>
          )}
        </div>
      </div>
    </div>
  );
};