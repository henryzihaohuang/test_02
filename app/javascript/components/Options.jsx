import React, { useState } from "react";
import useDidMountEffect from "hooks/useDidMountEffect";

import Select from "react-select";

export default function Options({ name,
                                  options,
                                  existingSelectedOptions }) {
  const MAX_NUMBER_OF_CHECKBOXES = 5;
  const [selectedOptions, setSelectedOptions] = useState(existingSelectedOptions);

  function handleCheckChange(option, event) {
    if (event.target.checked) {
      setSelectedOptions(selectedOptions.concat([option.name]));
    } else {
      const newSelectedOptions = selectedOptions.slice();

      newSelectedOptions.splice(newSelectedOptions.indexOf(option.name), 1);

      setSelectedOptions(newSelectedOptions);
    };
  };

  function handleSelectChange(unnecessary, action) {
    if (action.action === "select-option") {
      setSelectedOptions(selectedOptions.concat([action.option.value]));
    } else if (action.action === "clear") {
      const newSelectedOptions = selectedOptions.slice();

      action.removedValues.forEach(({ value }) => {
        newSelectedOptions.splice(newSelectedOptions.indexOf(value), 1);
      });

      setSelectedOptions(newSelectedOptions);
    } else if (action.action === "remove-value") {
      const newSelectedOptions = selectedOptions.slice();

      newSelectedOptions.splice(newSelectedOptions.indexOf(action.removedValue.value), 1);

      setSelectedOptions(newSelectedOptions);
    };
  };

  useDidMountEffect(() => {
    const event = new Event("liveFormController.apply");

    document.dispatchEvent(event);
  }, [selectedOptions]);

  function renderOption(option) {
    return (
      <div>
        <label className="checkbox">
          <input type="checkbox"
                 name={name}
                 value={option.value}
                 checked={selectedOptions.includes(option.value)}
                 onChange={handleCheckChange.bind(null, option)}
                 autoComplete="off" />

          {option.name} ({option.matchCount})
        </label>
      </div>
    );
  };

  return (
    <>
      {selectedOptions.filter(selectedOption => !!selectedOption && options.slice(MAX_NUMBER_OF_CHECKBOXES).map(option => option.value).includes(selectedOption)).map((selectedOption) => {
        return (
          <>
            <input type="hidden"
                   name={name}
                   value={selectedOption}
                   autoComplete="off" />
          </>
        );
      })}

      {options.slice(0, MAX_NUMBER_OF_CHECKBOXES).map(option => renderOption(option))}

      {options.length > MAX_NUMBER_OF_CHECKBOXES && (
        <div style={{ marginTop: "5px" }}>
          <Select options={options.slice(MAX_NUMBER_OF_CHECKBOXES).map((option) => {
            return {
              label: `${option.name} (${option.matchCount})`,
              value: option.value
            };
          })}
                  value={options.slice(MAX_NUMBER_OF_CHECKBOXES).filter(option => existingSelectedOptions.includes(option.value)).map(option => {
                    return {
                      label: `${option.name} (${option.matchCount})`,
                      value: option.value
                    };
                  })}
                  isMulti={true}
                  onChange={handleSelectChange} />
        </div>
      )}
    </>
  )
};