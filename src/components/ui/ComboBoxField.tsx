import { useTranslation } from "react-i18next";
import { useEffect, useRef, useState } from "react";

import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import type { IComboBox } from "@/interfaces/components/fields/IComboBox";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import ReadOnlyField from "@/components/fields/ReadOnlyField";
import IconSVG from "@/components/icons/IconSVG";
import { DropdownChevronIcon } from "@/assets/icons";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  id: string;
  label: string;
  items: IComboBox[];
  value: IComboBox | null;
  onChange: (item: IComboBox | null) => void;
  error?: string;
  placeholder?: string;
  loading?: boolean;
  readOnly?: boolean;
  required?: boolean;
}>;

const ComboBoxField = ({
  id,
  label,
  items,
  value,
  onChange,
  error = "",
  placeholder,
  loading,
  readOnly = false,
  required,
}: IProps) => {
  const { t } = useTranslation();
  const [open, setOpen] = useState(false);
  const [showAll, setShowAll] = useState(false);
  const [filter, setFilter] = useState("");
  const newPlaceholder = placeholder || t("dropdown.placeholder.default");
  const contenedorRef = useRef<HTMLDivElement>(null);
  const syncText = useRef(false);
  const errorStatus = error.trim() !== "";

  useEffect(() => {
    if (syncText.current) {
      syncText.current = false;
      return;
    }
    setFilter(value ? value.label : "");
  }, [value]);

  useEffect(() => {
    if (items.length === 1) {
      onChange(items[0]);
    }
  }, [items, onChange]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (
        contenedorRef.current &&
        !contenedorRef.current.contains(e.target as Node)
      ) {
        const match = items.find(
          (item) => (item.label ?? "").toLowerCase() === filter.toLowerCase(),
        );

        if (match) {
          setFilter(match.label);
          if (value?.value !== match.value) {
            onChange(match);
          }
        } else {
          onChange(null);
          setFilter("");
        }

        setOpen(false);
        setShowAll(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [filter, items, onChange, value]);

  const toggleDropdown = () => {
    const nextOpen = !open;
    setOpen(nextOpen);
    setShowAll(true);
    setFilter(value ? value.label : "");
  };

  const openDropdown = () => {
    if (loading) return;
    setOpen(true);
    setShowAll(true);
    setFilter(value ? value.label : "");
  };

  const normalizedItems = items.map((item) => ({
    value: String(item.value ?? ""),
    label: String(item.label ?? ""),
  }));

  const itemsFilter =
    showAll && !!value
      ? normalizedItems
      : normalizedItems.filter((item) =>
          item.label.toLowerCase().includes(filter.toLowerCase()),
        );

  const onSelect = (item: IComboBox) => {
    onChange(item);
    setFilter(item.label);
    setOpen(false);
    setShowAll(false);
  };

  if (items.length === 1) {
    return <ReadOnlyField id={id} label={label} description={items[0].label} />;
  } else {
    return (
      <Field className={`banrural-dropdown-item ${errorStatus && "error"}`}>
        <FieldLabel
          id={buildComponentId("lbl", id)}
          className="banrural-input-label text-base"
          htmlFor={buildComponentId("ddl", id)}
        >
          <strong>{label}</strong>
          {!required && (
            <span className="optional">{t("fields.optional")}</span>
          )}
        </FieldLabel>

        <div ref={contenedorRef} className="relative">
          <Button
            id={buildComponentId("ddl", id)}
            className="banrural-dropdown-shell w-full cursor-pointer"
            type="button"
            onClick={(e) => {
              const target = e.target;
              if (target instanceof HTMLInputElement) return;
              toggleDropdown();
            }}
          >
            <Input
              id={buildComponentId("txt", id)}
              value={filter}
              type="text"
              role="combobox"
              className="pl-5 pr-12 border-0 focus-visible:ring-0 aria-invalid:ring-0 h-full !text-base font-normal value"
              onPaste={(e) => e.preventDefault()}
              autoComplete="off"
              placeholder={loading ? t("loader.label") : newPlaceholder}
              disabled={loading}
              readOnly={readOnly}
              aria-expanded={open}
              aria-controls={buildComponentId("ddl", id)}
              aria-invalid={errorStatus}
              onFocus={openDropdown}
              onClick={openDropdown}
              required={required}
              maxLength={150}
              onChange={(e) => {
                const sanitized = e.target.value.replace(
                  /[^a-zA-ZáéíóúÁÉÍÓÚñÑ0-9\s]/g,
                  "",
                );
                setFilter(sanitized);
                setOpen(true);
                setShowAll(false);
                if (value) {
                  syncText.current = true;
                  onChange(null);
                }
              }}
            />
            <span
              className="bg-white banrural-dropdown-chevron"
              aria-hidden="true"
            >
              <IconSVG
                id="logo"
                src={DropdownChevronIcon}
                open={open}
                isDropdown
              />
            </span>
          </Button>
          {open && !loading && (
            <div
              id={buildComponentId("list", id)}
              className="absolute z-10 mt-1 bg-white border border-gray-200 max-h-60 overflow-auto left-0 right-0"
            >
              {itemsFilter.length > 0 ? (
                itemsFilter.map((item, index) => (
                  <Button
                    key={item.value}
                    id={buildComponentId("ddl", item.value)}
                    className="rounded-none w-full h-full text-base hover:bg-gray-100 cursor-pointer whitespace-normal break-words"
                    type="button"
                    role="option"
                    aria-selected={value?.value === item.value}
                    onClick={() => onSelect(item)}
                  >
                    <div
                      className={`w-full text-left py-2 border-gray-200 ${
                        index === itemsFilter.length - 1 ? "" : "border-b-1"
                      }`}
                    >
                      {item.label}
                    </div>
                  </Button>
                ))
              ) : (
                <div className="rounded-none w-full h-full text-base p-2 text-gray-500 left-0 right-0">
                  {t("dropdown.placeholder.noData")}
                </div>
              )}
            </div>
          )}
          {errorStatus && (
            <div className="banrural-input-item error">
              <FieldError
                id={buildComponentId("lbl", `${id}Error`)}
                className="banrural-input-help pt-1"
                errors={[{ message: error }]}
              />
            </div>
          )}
        </div>
      </Field>
    );
  }
};

export default ComboBoxField;
