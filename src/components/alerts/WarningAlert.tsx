import { WarningIcon } from "@/assets/icons";
import IconSVG from "@/components/icons/IconSVG";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  title: string;
  id?: string;
  description?: string;
}>;

const WarningAlert = ({ title, id = "warning", description }: IProps) => {
  return (
    <div
      id={buildComponentId("alert", id)}
      className="banrural-notification banrural-notification-warning !max-w-full"
    >
      <div className="banrural-notification-header">
        <span className="banrural-notification-icon" aria-hidden="true">
          <IconSVG id="alertWarning" src={WarningIcon} />
        </span>
        <div className="banrural-notification-body">
          <p
            id={buildComponentId("alert", `${id}Title`)}
            className="banrural-notification-title"
          >
            {title}
          </p>
          {description && (
            <p
              id={buildComponentId("alert", `${id}Description`)}
              className="banrural-notification-desc"
            >
              {description}
            </p>
          )}
        </div>
      </div>
    </div>
  );
};

export default WarningAlert;
