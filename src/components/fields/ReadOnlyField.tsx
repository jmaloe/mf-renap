import { Field, FieldDescription, FieldLabel } from "@/components/ui/field";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  id: string;
  label: string;
  description: string;
}>;

const ReadOnlyField = ({ id, label, description }: IProps) => {
  return (
    <Field className="banrural-input-item">
      <FieldLabel
        id={buildComponentId("lbl", id)}
        className="banrural-input-label text-base"
      >
        <strong>{label}</strong>
      </FieldLabel>
      <FieldDescription
        id={buildComponentId("txt", id)}
        className="text-forest-green-900 text-base"
      >
        {description}
      </FieldDescription>
    </Field>
  );
};

export default ReadOnlyField;
