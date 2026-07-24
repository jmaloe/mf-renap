import { useTranslation } from "react-i18next";
import { useEffect, useState } from "react";

import { Card, CardContent } from "@/components/ui/card";
import handleImageError from "@/utils/errors/handleImageError";
import loadMFConfig from "@/utils/bootstrap/mfHub/loadMFConfig";
import { PlaceholderImg } from "@/assets/img";
import { buildComponentId } from "@/utils/bootstrap/buildComponentId";

type IProps = Readonly<{
  description?: string;
}>;

const MainHeader = ({ description }: IProps) => {
  const { t } = useTranslation();
  const [logo, setLogo] = useState<string>(PlaceholderImg);

  useEffect(() => {
    const loadLogo = async () => {
      if (logo === PlaceholderImg) {
        const transaction = await loadMFConfig();
        if (transaction?.iconUrl && transaction.iconUrl.trim() !== "")
          setLogo(transaction.iconUrl);
      }
    };
    loadLogo();
  }, [logo]);

  return (
    <Card className="ring-0">
      <CardContent className="flex items-center banrural-card-form-section">
        <img
          className="banrural-card-form-logo"
          alt="icon-mf"
          src={logo}
          onError={handleImageError}
        />
        <div className="banrural-card-form-right">
          <p id={buildComponentId("lbl", "HeaderTitle")} className="banrural-card-form-title">
            {t("header.title")}
          </p>
          {description && (
            <p
              id={buildComponentId("lbl", "HeaderDescription")}
              className="banrural-card-form-description"
            >
              {description}
            </p>
          )}
        </div>
      </CardContent>
    </Card>
  );
};

export default MainHeader;
